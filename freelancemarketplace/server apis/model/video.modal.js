const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const videoSchema = new Schema({
    uid:{
        type:String,
    },
    tid:{
        type:String,
    },
    date:{
        type:String,
    },
});

const videoModel = db.model('video',videoSchema);
module.exports = videoModel;