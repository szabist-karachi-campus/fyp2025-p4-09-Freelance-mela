const app = require('express').Router();
const bookingmodel = require('../model/booking.modal');

app.post('/registerbooking', async (req, res, next) => {
    try{
        const {uid,pid,ppid,date,status,tracking} = req.body;
        const creteuser = new bookingmodel({uid,pid,ppid,date,status,tracking});
        await creteuser.save();
        res.json({status:true,message:"booking uploaded Sucessfully"});
    } catch (e){
        console.log(e)
        res.json({status:false,message:"server error controller register"});
    }
});

app.post('/allbooking', async (req, res, next) => {
    try{
        const user = await bookingmodel.find();
        res.status(200).json({data:user});       
    } catch (e){
        console.log(e)
        res.json({data:[]});
    }
});

app.post('/statusbookingchange', async (req, res, next) => {
    try{
        const {id,status} = req.body;
        await bookingmodel.findByIdAndUpdate(id,{$set:{status:status}});
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

app.post('/deletebooking', async (req, res, next) => {
    try{
        const {id} = req.body;
        await bookingmodel.findByIdAndDelete(id);
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

app.post('/updatebooking', async (req, res, next) => {
    try{
        const {id,uid,pid,ppid,date,status,tracking} = req.body;
        await bookingmodel.findByIdAndUpdate(id,{$set:{uid:uid,pid:pid,
            ppid:ppid,date:date,status:status,tracking:tracking}});
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

module.exports = app;
