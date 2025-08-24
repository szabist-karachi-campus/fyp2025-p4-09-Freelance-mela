const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
const connection = mongoose.createConnection('mongodb://127.0.0.1:27017/freelancing',{
    useNewUrlParser: true,
    useUnifiedTopology: true
})
    .on('open',()=>{
    console.log('MongoDb connected');
}).on('error',()=>{
    console.log('MongoDb error');
});

module.exports = connection;
