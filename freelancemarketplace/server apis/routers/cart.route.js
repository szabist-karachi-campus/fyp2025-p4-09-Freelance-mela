const app = require('express').Router();
const cartmodel = require('../model/cart.modal');

app.post('/registercart', async (req, res, next) => {
    try{
        const {uid,pid,ppid} = req.body;
        const creteuser = new cartmodel({uid,pid,ppid});
        await creteuser.save();
        res.json({status:true,message:"cart uploaded Sucessfully"});
    } catch (e){
        console.log(e)
        res.json({status:false,message:"server error controller register"});
    }
});

app.post('/allcart', async (req, res, next) => {
    try{
        const user = await cartmodel.find();
        res.status(200).json({data:user});       
    } catch (e){
        console.log(e)
        res.json({data:[]});
    }
});


app.post('/deletecart', async (req, res, next) => {
    try{
        const {id} = req.body;
        await cartmodel.findByIdAndDelete(id);
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});


module.exports = app;
