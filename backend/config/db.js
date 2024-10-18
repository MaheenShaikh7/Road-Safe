const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb+srv://luckyvishwa1104:lucky1104@cluster0.i72lmi2.mongodb.net/UserLoginDetails?retryWrites=true&w=majority').on('open', () => {
    console.log("MongoDB Connected.");
}).on('error', () => {
    console.log("MongoDB not connected.")
});

//mongodb://127.0.0.1:27017/UserLoginDetails - for local
//mongodb+srv://luckyvishwa1104:lucky1104@cluster0.i72lmi2.mongodb.net/UserLoginDetails?retryWrites=true&w=majority&appName=Cluster0 - for remote

module.exports = connection;