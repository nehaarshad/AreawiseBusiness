import multer from "multer";
import path from "path";
import fs from "fs";
import {v4 as uuidv4} from "uuid"; //universal unique identifier

import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// defines the storage engine (destination: where file uploads) and the file name(give unique name to each file)
const storage = multer.diskStorage({  ///permanently store the image into the server
    destination: function(req, file, cb) {
              //const {entity,entityid}=req.params;
            //  console.log(entity);
          //    let dest = path.join(__dirname, '..', 'uploads' ,entity,entityid.toString());
         let dest = path.join(__dirname, '..', 'uploads' );///path of the directory where image will be stored
        //dest=>backend_code/uploads/product/1
        if (!fs.existsSync(dest)) {
            fs.mkdirSync(dest, { recursive: true });  //create directory if not exist specifically when new product or user or shop is added then new directory will be created
            fs.chmodSync(dest, 0o755);  //ensure that directory is created with read,write and execute permission
        }

        cb(null, dest);
    },
    //give unique name to each file
    filename: function(req, file, cb) {
        const uniquename = Date.now() + '-' + uuidv4();
        cb(null, file.fieldname + '-' + uniquename + path.extname(file.originalname));
    }
});

const filefilter = (req, file, cb) => {
    const allowedexe = /jpeg|jpg|png|gif/;
    const extname = allowedexe.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedexe.test(file.mimetype);

    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb('Error: Images Only!');
    }
};

// upload middleware
const upload = multer({
    storage: storage,
    limits: { fileSize: 5000000 }, // 5MB limit
    fileFilter: filefilter
});

export default upload;