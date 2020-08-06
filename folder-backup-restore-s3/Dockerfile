FROM mikesir87/aws-cli

RUN apt-get update

RUN apt-get install -y rsync

WORKDIR /app
ADD run.sh ./
RUN chmod +x run.sh

CMD [ "sh", "run.sh" ]
