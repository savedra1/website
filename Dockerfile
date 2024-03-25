# nginx host

FROM nginx:alpine

COPY ./website/ /usr/share/nginx/html

EXPOSE 80

# To Run:
#   docker build -t web-image:v1 .
#   docker run -d -p 80:80 html-server-image:v1
#   curl localhost:80
#

































