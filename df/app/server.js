const http = require("http");
const child_process = require("child_process");

console.log("Started");

http
    .createServer((req, res) => {
        console.log(req.method);
        console.log(req.headers);
        console.log(req.url);
        console.log(/^(\/[a-zA-Z0-9\s]*)+$/.test(req.url))
        
        if (!/^(\/[a-zA-Z0-9\s]*)+$/.test(req.url)) {
            res.statusCode = 400;
            res.end();
        } else {
            const cmd = `df -m "${req.url}" | tail -1`;
            
            child_process.exec(cmd, (err, result) => {
                const keys = ["blocks", "used", "available", "percent", "mountpoint"];
                const data = result.toString().split(/[%\s]+/).slice(1)
                    .reduce((agg, curr, index) => Object.assign(agg, { [keys[index]]: curr  }), {});

                res.setHeader("content-type", "application/json")
                res.write(JSON.stringify(data));
                res.end();
            });
        }
    })
    .listen(process.env.HTTP_PORT);