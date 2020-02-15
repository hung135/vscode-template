FROM buildbase
 
RUN mkdir -p /Build/
WORKDIR /Build/
COPY version.py /Build/src/
COPY scripts/ /Build/src/
ENV PYTHONPATH="/Build/src/"
RUN pwd
RUN pip3 install -r src/requirements.txt
RUN head -n -1 /Build/src/version.py >/Build/src/version2.py
RUN mv /Build/src/version2.py /Build/src/version.py

#inject distro into version.py
RUN echo ",\"distro\":\"\"\"">>src/version.py
RUN cat /etc/redhat-release >>src/version.py
RUN echo "\"\"\"">>src/version.py

#inject libs into version.py
RUN echo ",\"python_libs\":\"\"\"" >>/Build/src/version.py
RUN pip freeze >>/Build/src/version.py
RUN echo "\"\"\"}" >>/Build/src/version.py
#RUN pyinstaller src/switchboard.py  --add-data /Build/src/version.txt:.  --onefile
RUN pyinstaller src/switchboard.py  --onefile --paths $PYTHONPATH
RUN mkdir tmp 
RUN tar -czvf switchboard_centos_6_10.tar -C /Build/dist/ . 
RUN tar -xvf ./switchboard_centos_6_10.tar -C ./tmp/
# RUN pip3 install -r src/requirements.txt
# RUN pyinstaller src/switchboard.py -w --onefile
# RUN tar -czvf switchboard.tar -C dist/ .

#for testing
ENV PGHOST=db
ENV PGDATABASE=postgres
ENV PGUSER=postgres
ENV PGPASSWORD=docker
ENV PGPORT=5432 