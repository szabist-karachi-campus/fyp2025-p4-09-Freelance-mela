const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const complainsSchema = new Schema({
    uid:{
        type:String,
    },
    title:{
        type:String,
    },
    ans:{
        type:String,
    },
});

const complainsModel = db.model('complains',complainsSchema);
module.exports = complainsModel;