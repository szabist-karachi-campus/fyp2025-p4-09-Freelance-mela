const complains = require('../model/complains.modal');
const app = require('express').Router();

app.post('/registercomplains', async (req, res, next) => {
    try {
      const { uid,title, ans} = req.body;
      const user = new complains({ uid,title, ans});
      await user.save();
      res.status(200).json({ status:true ,message:"register sucessfully"});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false,message:"try again later" });
    }
});


app.post('/allcomplains', async (req, res, next) => {
    try {
      const user = await complains.find();
      res.status(200).json({ status:true ,data:user});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false,data:[] });
    }
});


module.exports = app;