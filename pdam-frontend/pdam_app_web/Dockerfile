FROM node:16.17.1-alpine AS build
WORKDIR /app
COPY . .
RUN npm ci && npm run build
FROM nginx:alpine
COPY --from=build /app/dist/pdam_app_web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]