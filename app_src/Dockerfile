FROM ubuntu:latest
RUN echo Updating existing packages, installing and upgrading python and pip.
RUN apt-get update -y
RUN apt-get upgrade -y

# Unable to locate package python-pipの場合はpython3-pipのようにバージョンが異なる。
# ubuntuのバージョンに依存
RUN apt-get install -y python3-pip python3-dev build-essential

# pipバージョンもpipやpip3など合わせる
# ex. pip3 install --upgrade pip
RUN pip3 install --upgrade pip
RUN echo Copying the Mythical Mysfits Flask service into a service directory.
COPY ./service /MythicalMysfitsService
WORKDIR /MythicalMysfitsService
RUN echo Installing Python packages listed in requirements.txt

# pipバージョンもpipやpip3など合わせる
RUN pip3 install -r ./requirements.txt
RUN echo Starting python and starting the Flask service...
ENTRYPOINT ["python"]
CMD ["mythicalMysfitsService.py"]
