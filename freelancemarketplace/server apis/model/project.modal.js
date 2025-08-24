const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const projectSchema = new Schema({
    title:{
        type:String,  
    },
    des:{
        type:String,
    },
    img:[],
    price:{
        type:String,
    },
    status:{
        type:String,
    },
    uid:{
        type:String,
    }
});

const projectModel = db.model('project',projectSchema);
module.exports = projectModel;