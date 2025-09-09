import multer from "multer";
import path from "path";
import fs from "fs";
import { v4 as uuidv4 } from "uuid";
import { fileURLToPath } from 'url';
import sharp from 'sharp'; 

const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);

const IMAGE_CONFIG = {
    width: 800,
    height: 800,
    quality: 85,
    format: 'webp'
};

const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        let dest = path.join(dirname, '..', 'uploads');
        
        if (!fs.existsSync(dest)) {
            fs.mkdirSync(dest, { recursive: true });
            fs.chmodSync(dest, 0o755);
        }
        
        cb(null, dest);
    },
    filename: function(req, file, cb) {
        const uniquename = Date.now() + '-' + uuidv4();
        const filename = file.fieldname + '-' + uniquename + '.webp';
        cb(null, filename);
    }
});

const filefilter = (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb(new Error('Images Only! Allowed formats: JPEG, JPG, PNG, GIF, WebP'));
    }
};

// Create and export the multer instance directly
const upload = multer({
    storage: storage,
    limits: { 
        fileSize: 10 * 1024 * 1024,
        files: 10
    },
    fileFilter: filefilter
});

// Function to optimize image
const optimizeImage = async (originalPath, outputPath) => {
    try {
        await sharp(originalPath)
            .resize(IMAGE_CONFIG.width, IMAGE_CONFIG.height, {
                fit: 'inside', 
                withoutEnlargement: true 
            })
            .webp({ 
                quality: IMAGE_CONFIG.quality,
                effort: 4
            })
            .toFile(outputPath);
            
        fs.unlinkSync(originalPath);
        return true;
    } catch (error) {
        console.error('Image optimization error:', error);
        throw error;
    }
};

// Export the multer instance directly and other utilities as named exports
export { upload, optimizeImage, IMAGE_CONFIG };