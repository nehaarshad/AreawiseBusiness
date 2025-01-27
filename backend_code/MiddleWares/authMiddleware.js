import jwt from "jsonwebtoken";
import user from "../models/seqModelSync.js"

const auth = async (req, res, next) => {
    let token;

    if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
        try {
            token = req.headers.authorization.split(" ")[1];
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            req.user = await user.findByPk(decoded.id, { attributes: { exclude: ["password"] } });

            if (!req.user) {
                return res.status(401).json({ message: "User not found" });
            }

            next();
        } catch (error) {
            return res.status(401).json({ message: "Invalid token" });
        }
    } 
    else {
        return res.status(401).json({ message: "Not authorized, no token" });
    }
};

export default {auth};
