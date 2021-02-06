const express = require("express");
const app = express();
const port = process.env.PORT;


app.get("/test", (req, res) => {
	res.send(`Our api server is working correctly use port ${port}`);
});

app.listen(port, ()=> {
	console.log(`Started api service ${port}`);
});

