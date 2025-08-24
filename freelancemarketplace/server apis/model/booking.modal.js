const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const bookingSchema = new Schema({
    uid:{
        type:String,
    },
    pid:{
        type:String,
    },
    ppid:{
        type:String,
    },
    date:{
        type:String,
    },
    status:{
        type:String,
    },
    tracking:{
        type:String,
    },
});

const bookingModel = db.model('booking',bookingSchema);
module.exports = bookingModel;
