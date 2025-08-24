const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const cartSchema = new Schema({
    uid:{
        type:String,
    },
    pid:{
        type:String,
    },
    ppid:{
        type:String,
    }
});

const cartModel = db.model('cart',cartSchema);
module.exports = cartModel;
