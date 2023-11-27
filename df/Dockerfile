FROM node:alpine

#Copy our conf into the nginx http.d folder.
COPY app /app

#Launch nginx with debug options.
CMD ["node", "/app/server.js"]
