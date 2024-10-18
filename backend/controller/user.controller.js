const { response } = require('../app');
const UserService = require('../services/user.services');

exports.register = async (req, res, next) => {
    try {
        const { userImage, firstName, lastName, email, password } = req.body;
        const successRes = await UserService.registerUser(userImage, firstName, lastName, email, password);

        res.json({ status: true, success: "User Registered Successfully" });
    }
    catch (error) {
        res.json({ "msg": error });
    }
}

exports.uploadUserPhoto = async (req, res, next) => {
    try {
        const { email } = req.body;

        const { type } = req.body;

        let photoUpload = await UserService.uploadUserPhoto(email, type);

        res.json({ status: true, success: photoUpload });
    }
    catch (error) {
        next(error);
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserService.checkuser(email);

        if (!user) {
            res.json({ msg: "user does not exist" })
            return;
        }

        const isMatch = await user.comparePassword(password);
        if (isMatch == false) {
            res.json({ msg: "password is invalid" })
            return;
        }

        let tokenData = { _id: user._id, email: user.email, firstName: user.firstName, lastName: user.lastName };

        const token = await UserService.generateToken(tokenData, "secretkey", '10m')

        res.status(200).json({ status: true, token: token })

    }
    catch (error) {
        throw error
    }
}

exports.userDetails = async (req, res, next) => {
    try {
        const { email } = req.body;

        let userDetails = await UserService.userDetails(email);

        res.json({ status: true, success: userDetails });
    }
    catch (error) {
        next(error);
    }
}
