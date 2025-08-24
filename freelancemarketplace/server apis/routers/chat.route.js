const chat = require('../model/chat.modal');
const app = require('express').Router();

app.post('/registerchat', async (req, res, next) => {
    try {
      const { uid, did, c, date } = req.body;
        const existingChat = await chat.findOne({ uid, did });  
      if (existingChat) {
        res.status(200).json({ status: true, message: existingChat._id, did: existingChat.did, });
      } else {
        const newChat = new chat({ uid, did, c, date });
        await newChat.save();
        res.status(200).json({ status: true, message: newChat._id,did:newChat.did, });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ status: false, message: '',did:"", });
    }
});


app.post('/allchatbyid', async (req, res, next) => {
    try {
        const {id} = req.body;
      const user = await chat.findById(id);
      res.status(200).json({ status:true ,data:user});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false,data:[] });
    }
});

app.post('/allchatbydid', async (req, res, next) => {
  try {
    const { did } = req.body;
    const user = await chat.find({ $or: [{ uid: did }, { did: did }] });
    res.status(200).json({ status: true, data: user });
  } catch (error) {
    console.log(error);
    res.status(500).json({ status: false, data: [] });
  }
});
  

app.post('/addchat', async (req, res, next) => {
    try {
    const { id,data } = req.body;
      const user = await chat.findById(id);
      user.c.push(data);
      await chat.findByIdAndUpdate(id,{$set:{c:user.c}});
      res.status(200).json({ status:true});
    } catch (error) {
      console.log(error);
      res.status(500).json({ status:false });
    }
});

module.exports = app;