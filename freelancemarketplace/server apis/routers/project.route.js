const app = require('express').Router();
const projectmodel = require('../model/project.modal');

app.post('/registerproject', async (req, res, next) => {
    try{
        const {title,des,img,price,status,uid} = req.body;
        const creteuser = new projectmodel({title,des,img,price,status,uid});
        await creteuser.save();
        res.json({status:true,message:"projcet uploaded Sucessfully"});
    } catch (e){
        console.log(e)
        res.json({status:false,message:"server error controller register"});
    }
});

app.post('/allproject', async (req, res, next) => {
    try{
        const user = await projectmodel.find();
        res.status(200).json({data:user});       
    } catch (e){
        console.log(e)
        res.json({data:[]});
    }
});

app.post('/statuschange', async (req, res, next) => {
    try{
        const {id,status} = req.body;
        await projectmodel.findByIdAndUpdate(id,{$set:{status:status}});
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

app.post('/deleteproject', async (req, res, next) => {
    try{
        const {id} = req.body;
        await projectmodel.findByIdAndDelete(id);
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

app.post('/getoneproject', async (req, res, next) => {
    try{
        const {id} = req.body;
        const pro = await projectmodel.findById(id);
        res.status(200).json({data:pro});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

app.post('/updateproject', async (req, res, next) => {
    try{
        const {id,title,des,img,price} = req.body;
        await projectmodel.findByIdAndUpdate(id,{$set:{title:title,des:des,img:img,price:price}});
        res.status(200).json({status:true});       
    } catch (e){
        console.log(e)
        res.json({status:false});
    }
});

module.exports = app;
