const jwt = require("jsonwebtoken");
const User = require("../models/User");


const verifyToken = (req, res, next)=> {
    const authHeader = req.headers.authorization;

    if(authHeader){
        const token = authHeader.split(" ")[1];

        jwt.verify(token, process.env.JWT_SEC, async (err, user) => {
            if(err){
                return res.status(403).json({status: false, message: "Invalid token"})
            }

            req.user = user;
            next();
        })

    }else{
        return res.status(401).json({status: false, message: "You are not authenticated"})
    }
}

const verifyTokenAndAuthorization = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.userType === 'Client' || req.user.userType === 'Driver' || req.user.userType === 'Vendor'|| req.user.userType === 'Admin') {
            next();
        } else {
            res.status(403).json("You are restricted from perfoming this operation");
        }
    });
};

const verifyVendor = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.userType === "Vendor" || req.user.userType === "Admin") {
            next();
        } else {
            res.status(403).json("You have limited access");
        }
    });
};


const verifyDriver = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.userType === "Driver" || req.user.userType === "Admin") {
            next();
        } else {
            res.status(403).json("You are restricted from perfoming this operation");
        }
    });
};


const verifyAdmin = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.userType === "Admin") {
            next();
        } else {
            res.status(403).json("You are restricted from perfoming this operation");
        }
    });
};

module.exports = { verifyToken, verifyTokenAndAuthorization, verifyVendor, verifyDriver, verifyAdmin };
