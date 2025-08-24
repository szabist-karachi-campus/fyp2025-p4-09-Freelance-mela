const video = require('../model/video.modal');
const app = require('express').Router();

app.post('/registervideo', async (req, res, next) => {
    try {
      const { uid,tid, date} = req.body;
      const user = new video({ uid,tid, date});
      await user.save();
      res.status(200).json({ status:true ,message:"register sucessfully"});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false,message:"try again later" });
    }
});

app.post('/allvideo', async (req, res, next) => {
    try {
      const user = await video.find();
      res.status(200).json({ status:true ,data:user});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false,data:[] });
    }
});

module.exports = app;

