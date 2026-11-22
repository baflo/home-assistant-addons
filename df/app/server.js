const http = require("http");
const { execFile } = require("child_process");

http.createServer((req, res) => {
    let path;
    try {
        path = decodeURIComponent(req.url.split("?")[0]);
    } catch {
        res.statusCode = 400;
        return res.end();
    }

    execFile("df", ["-m", path], (err, stdout) => {
        if (err) {
            res.statusCode = 404;
            return res.end();
        }
        const lastLine = stdout.trim().split("\n").pop();
        const keys = ["blocks", "used", "available", "percent", "mountpoint"];
        const data = lastLine.split(/[%\s]+/).slice(1)
            .reduce((agg, curr, i) => Object.assign(agg, { [keys[i]]: curr }), {});

        res.setHeader("content-type", "application/json");
        res.end(JSON.stringify(data));
    });
}).listen(process.env.HTTP_PORT);