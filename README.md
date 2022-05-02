# fastapi-redisTimeseries

This repo is inspired by [this](https://developer.redis.com/develop/python/fastapi/) brilliant blog. You should definitely check it out.

I make some modifications:
- main app (e.g added some asyncio.gather here and there to optimize asyncronicity)
- Dockerfile (I have started from scratch i.e. not using tiangolo's image, but added some tricks found in Fastapi [docs](https://fastapi.tiangolo.com/deployment/docker/?h=docker#docker-image-with-poetry))
- compose.yaml file (I still need time to understand what is happening in the tests folder XD)