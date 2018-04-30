-- tttc_classdrop
AddCSLuaFile()

local ENT = {}
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "tttc_classdrop"
ENT.Instructions = "Drops a custom class!"
ENT.Spawnable = true
ENT.Author = "Alf21"
ENT.Purpose = "For TTTC"

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS) 
    end

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:SetMass(50)
    end
end

if SERVER then
    function ENT:TakeClass(ply)
        if not ply or not IsValid(ply) or not ply:IsPlayer() or not ply:IsActive() or ply:HasWeapon("weapon_ttt_classdrop") then return end

        -- should never happen
        if ply:HasCustomClass() then
            ply:ResetCustomClass()
        end

        ply:UpdateCustomClass(self:GetNWInt("customClass"))
        
        for _, v in pairs(self.classWeapons) do
            ply:GiveClassWeapon(v:GetClass())
            
            ply:GiveAmmo(v:Ammo1(), v:GetPrimaryAmmoType(), true)
            ply:GiveAmmo(v:Ammo2(), v:GetSecondaryAmmoType(), true)
        end
        
        ply:Give("weapon_ttt_classdrop")
        
        for _, v in pairs(self.classEquipment) do
            ply:GiveClassEquipmentItem(v)
        end
        
        for k, v in pairs(DROPCLASSENTS) do
            if v == self then
                table.remove(DROPCLASSENTS, k)
                
                self:Remove()
            end
        end
    end

    function ENT:Use(activator)
        self:TakeClass(activator)
    end
end
    
if CLIENT then
    local GetLang

    function ENT:Draw()
        if IsValid(self) then
            GetLang = GetLang or LANG.GetUnsafeLanguageTable
            
            local L = GetLang()
        
            self:DrawModel()
            
            local pos = self:GetPos() + Vector(0, 0, 20)
            local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
            
            surface.SetFont("Default")
            
            local txt = L[GetClassByIndex(self:GetNWInt("customClass")).name]
            local width = surface.GetTextSize(txt) + 55

            cam.Start3D2D(pos, ang, 0.3)

            draw.RoundedBox(5, -width / 2 , -30, width, 15, Color(10, 90, 140, 100))
            draw.SimpleText(txt, "ChatFont", 0, -30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            
            cam.End3D2D()
        end
    end
end
scripted_ents.Register(ENT, "tttc_classdrop", true)