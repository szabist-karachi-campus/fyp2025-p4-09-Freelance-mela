const app = require('./app');
const db = require('./config/db');

const port = 3000;
const localhost = '192.168.0.102';

app.get('/',(req,res)=>{
    res.send('Hello World !!!!!')
})

app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})
