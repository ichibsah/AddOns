local addon, ns = ...
local engine = LibStub('AceAddon-3.0'):NewAddon(addon, 'AceEvent-3.0');
local locale = LibStub('AceLocale-3.0'):GetLocale(addon, true);

ns[1] = engine;
ns[2] = locale;

OrderHallFollowerGearOptimizer = ns;

engine.Title = GetAddOnMetadata(addon, "Title")
engine.Version = GetAddOnMetadata(addon, "Version")

