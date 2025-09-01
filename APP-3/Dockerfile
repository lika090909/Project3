FROM amazonlinux:2023

RUN dnf -y update && \
    dnf -y install awscli jq java-17-amazon-corretto && \
    dnf clean all

WORKDIR /app

# Copy your WAR file
COPY usermgmt-webapp.war /app/usermgmt-webapp.war

# Copy entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]