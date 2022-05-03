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

# 
WORKDIR /code

# 
COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 
COPY ./app /code/app


RUN addgroup --gid 1001 --system app && \
    adduser --no-create-home --shell /bin/false --disabled-password --uid 1001 --system --group app

USER app


ENV PORT=80 \
    HOST=0.0.0.0 \
    PYTHONDONTWRITEBYTECODE=1
# 
CMD exec uvicorn app.main:app --host $HOST --port $PORT
