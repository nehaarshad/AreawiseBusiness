import bcrypt from "bcryptjs";
import User from "../models/userModel.js"
import generateToken from "../utils/generateToken.js";
import TokenBlacklist from "../models/tokenblacklist.js"

const createNewUser = async (req, res) => {

    try{
        const { username, email,contactnumber, password, role } = req.body;

        if(!username||!email||!password  ){
            return res.json({message:"All fields are required to filled!"})
        }
       else{
        const existingUser = await User.findOne({ where: { username } });
        if (existingUser) {
            return res.json({message: "User Already Exist" });
        }
        else{
        const hashedPassword = await bcrypt.hash(password, 10);
    
        const newuser = await User.create({ username, email,contactnumber, password: hashedPassword, role });
    
        res.json({ 
            id: newuser.id, 
            username: newuser.username, 
            email: newuser.email,
            contactnumber:newuser.contactnumber, 
            role: newuser.role, 
            token: generateToken(newuser.id) 
        });
        }
       }

    }catch(error){
        console.log(error);
        res.json({error:"Internal Server Error"})
    }

};

const forgetPassword = async (req, res) => {
    try {
        const { email ,password } = req.body;

        const user = await User.findOne({ where: { email } });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        await User.update({ password: hashedPassword }, { where: { email } });
        res.status(200).json({ message: "Password updated successfully" });

    } catch (error) {
        console.error("Error in forgetPassword:", error);
        res.status(500).json({ message: "Internal server error" });
    }
};

const loginUser = async (req, res) => {
    try{
    const { username, password } = req.body;

    if(!username ||!password ){
        return res.json("All fields are required to filled!")
    }
    else{
    const existingUser = await User.findOne({ where: { username } });

    if (existingUser) {

        const checkpassword=await bcrypt.compare(password, existingUser.password);

        if(!checkpassword){

            res.status(401).json({ message: "Incorrect Password" });
        }
        else{
            res.json({ 
                id: existingUser.id, 
                username: existingUser.username, 
                email: existingUser.email,
                contactnumber:existingUser.contactnumber, 
                role: existingUser.role, 
                token: generateToken(existingUser.id) 
            });
        }
       
    } 
    else {
        res.status(401).json({ message: "User not Found!" });
    }
    }
   }catch(error){
    console.log(error);
    res.json({error:"Internal Server Error"})
    }
};

const logout=async(req,res)=>{
    
        try {
            const token = req.header('Authorization'); 
    
            if (!token) {
                return res.status(401).json({ message: 'No token provided' });
            }
    
            await TokenBlacklist.create({ token });
            console.log('Logged out successfully');
            return res.status(200).json({ message: 'Logged out successfully' });
        } catch (error) {
            console.log(error);
            return res.status(500).json({ message: 'Server error' });
        }
    
}
export default { createNewUser, loginUser,logout ,forgetPassword };
