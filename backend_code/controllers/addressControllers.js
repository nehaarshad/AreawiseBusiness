import Address from "../models/addressmodel.js";
import User from "../models/userModel.js";

const addAddress = async (req, res) => {
    const { id } = req.params;
    const { address, city, state, sector } = req.body;
    try {
        const user = await User.findByPk(id);
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        const userId = user.id;
        const newAddress = await Address.create({ address, city, state, sector, userId });
        await newAddress.save();
        res.status(201).json(newAddress);
    } catch (err) {
        res.status(500).json(err);
    }
};

const getAddress = async (req, res) => {
    const { id } = req.params;
    try {
        const user = await User.findByPk(id);
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        const userId = user.id;
        const address = await Address.findAll({ where: { userId } });
        res.status(200).json(address);
    } catch (err) {
        res.status(500).json(err);
    }
};

const updateAddress = async (req, res) => {
    const { id } = req.params;
    const { address, city, state, sector } = req.body;
    try {
        const user = await User.findByPk(id);
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        const userId = user.id;
        const loc = await Address.findOne({ where: { userId } });
        if (!loc) {
            return res.json({ error: "Address not Found" });
        }
        const updatedAddress = {
        address:address || loc.address,
        city  :city || loc.city,
        state :state || loc.state,
        sector : sector || address.sector,
        }

        await loc.update(updatedAddress);
        res.status(200).json("address updated successfully");
    } catch (err) {
        res.status(500).json(err);
    }
};

const deleteAddress = async (req, res) => {
    const { id } = req.params;
    try {
        const user = await User.findByPk(id);
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        const userId = user.id;
        const address = await Address.findOne({ where: { userId } });
        if (!address) {
            return res.json({ error: "Address not Found" });
        }
        await address.destroy();
        res.status(200).json({ success: true, message: "Address Deleted Successfully" });
    } catch (err) {
        res.status(500).json(err);
    }
};

export default { addAddress, getAddress, updateAddress, deleteAddress };

