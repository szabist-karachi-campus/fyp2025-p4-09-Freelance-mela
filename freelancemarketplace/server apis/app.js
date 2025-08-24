const express = require("express");
const bodyParser = require("body-parser")
const cors = require('cors');
const UserRoute = require("./routers/user.route");
const projectRoute = require("./routers/project.route");
const chatRoute = require("./routers/chat.route");
const faqRoute = require("./routers/faqs.route");
const complainsRoute = require("./routers/complains.route");
const videoRoute = require("./routers/video.route");
const bookingRoute = require("./routers/booking.route");
const cartRoute = require("./routers/cart.route");

const app = express();
app.use(bodyParser.json());
app.use(cors());

app.use("/",UserRoute);
app.use("/",projectRoute);
app.use("/",chatRoute);
app.use("/",faqRoute);
app.use("/",complainsRoute);
app.use("/",videoRoute);
app.use("/",bookingRoute);
app.use("/",cartRoute);

module.exports = app;
