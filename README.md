# Flutter & Firebase Docker
### Run Locally

With a shell during runtime:
```docker run -it schradert/flutter-firebase-alpine sh```

Open a volume to run working directory:
```docker run -it -p 5000:5000 -v $PWD:/lib schradert/flutter-firebase-alpine run --allow-net /lib/main.dart```

### In a Dockerfile

```
FROM schradert/flutter-firebase-alpine

EXPOSE 5000

WORKDIR /home/developer

USER developer

COPY . .
CMD ["flutter", "run"]
```