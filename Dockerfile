FROM python:3.10.4-slim-bullseye as requirements-stage

# 
WORKDIR /tmp

ENV POETRY_VERSION=1.1.13

# 
RUN pip install "poetry==$POETRY_VERSION"

# 
COPY ./pyproject.toml ./poetry.lock* /tmp/

# 
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# 
FROM python:3.10.4-slim-bullseye

ARG port=3000 \
    host=0.0.0.0 \
    app_module=app.main:app

# 
WORKDIR /code

# 
COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY ./start-reload.sh /start-reload.sh

RUN chmod +x /start-reload.sh

# 
COPY ./app /code/app


RUN addgroup --gid 1001 --system app && \
    adduser --no-create-home --shell /bin/false --disabled-password --uid 1001 --system --group app

USER app


ENV PORT=${port} \
    HOST=${host} \
    APP_MODULE=${app_module} \
    PYTHONDONTWRITEBYTECODE=1
# 
# CMD exec uvicorn app.main:app --host $HOST --port $PORT
CMD [ "/start-reload.sh" ]