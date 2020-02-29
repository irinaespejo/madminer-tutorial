###############################
#
# Dockerfile for MG5 Pythia Delphes and patches for Madminer deployment
# BINDER version
###############################

FROM rootproject/root-ubuntu16:6.12

#create user
ARG NB_USER=joyvan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home

USER root

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

#install basics
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates python gfortran build-essential ghostscript vim libboost-all-dev \
    && apt-get -y install python-pip 


#
# MadGraph + Pythia + Delphes
#

WORKDIR ${HOME}/software

ENV MG_EPOCH = "2.6.x"
ENV MG_VERSION="MG5_aMC_v2_6_7" 
ENV MG_VERSION_WEB="MG5_aMC_v2.6.7" 

RUN curl -sSL https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.7.tar.gz | tar -xzv
RUN ./${MG_VERSION}/bin/mg5_aMC

#config path
WORKDIR ${HOME}/software/${MG_VERSION}
ENV ROOTSYS /usr/local 
ENV PATH $PATH:$ROOTSYS/bin 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ROOTSYS/lib

RUN echo "install lhapdf6" | ${HOME}/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install pythia8" | ${HOME}/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install pythia-pgs" | ${HOME}/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install Delphes" | ${HOME}/software/${MG_VERSION}/bin/mg5_aMC

#
# python packages
#


RUN pip install --upgrade pip && pip install --no-cache-dir notebook==5.* && pip install PyYAML  && pip install madminer


#
# code  wflow
#

WORKDIR ${HOME}
COPY dependencies/code/ ./code
RUN chmod 755 -R ./code

#
# code tutorial
#
COPY . ${HOME}


#
# change permissions of home
#

USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}


WORKDIR ${HOME}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]