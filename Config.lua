function AAM_InitConfigDB()
    if not ArwicAltManagerDB then ArwicAltManagerDB = {} end
    if not ArwicAltManagerDB.Config then ArwicAltManagerDB.Config = {} end
    local config = ArwicAltManagerDB.Config
    if not config.GoldThreshold then config.GoldThreshold = 10000 end
    if not config.MountSpeedThreshold then config.MountSpeedThreshold = 310 end
    if not config.ArtifactRankThreshold then config.ArtifactRankThreshold = 52 end
    if not config.OrderHallResourcesThreshold then config.OrderHallResourcesThreshold = 4000 end
    if not config.LevelThreshold then config.LevelThreshold = 110 end
end

AAM_InitConfigDB()