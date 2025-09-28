import path from "path";
import { fileURLToPath } from "url";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
import fs from "fs";

const removeImageFromDirectory = async (imageUrl) => {
  try {
    const oldPath = path.join(dirname, '..', 'uploads', path.basename(imageUrl)); //extract filename from URL optimized-Image-12345.webp only
    if (fs.existsSync(oldPath)) {
      fs.unlinkSync(oldPath);
    }
  } catch (error) {
    console.error('Error deleting image from directory:', error);
    throw error;
  }
}

export default removeImageFromDirectory;


