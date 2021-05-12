FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV PORT 8080
EXPOSE 8080
WORKDIR /usr/src/app

USER 0
RUN microdnf install python38 python3-virtualenv \
    && microdnf clean all

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY imagelookup /usr/src/app/imagelookup
RUN chown -R 1001:0 ${VIRTUAL_ENV} && \
    chown -R 1001:0 /usr/src/app/imagelookup

USER 1001
WORKDIR /usr/src/app/imagelookup
RUN pip3 install -U pip wheel && \
    pip3 install --no-cache-dir -r requirements.txt

CMD [ "python", "app.py"]
