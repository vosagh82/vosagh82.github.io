FROM alpine
RUN apk add --no-cache nginx && mkdir -p /run/nginx
EXPOSE 80
COPY . /opt/
COPY custom.conf /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]
