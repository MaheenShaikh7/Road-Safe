const router = require('express').Router();
const UserController = require('../controller/user.controller');

router.post('/registration', UserController.register);

router.post('/login', UserController.login);

router.post('/userDetails', UserController.userDetails);

router.post('/uploadUserPhoto', UserController.uploadUserPhoto);

module.exports = router;