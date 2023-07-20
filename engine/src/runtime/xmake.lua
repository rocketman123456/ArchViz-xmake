target("ArchVizRuntime", function ()
    set_kind("static")
    add_includedirs("$(projectdir)/engine/src", {public = true})
    add_headerfiles("core/base/*.h")
    add_files("core/base/*.cpp")
    add_packages("json11", {public = true})
    -- set_configvar("ENGINE_RUNTIME_HEADS", "$(projectdir)/engine/src/**.h")
    -- add_configfiles("$(projectdir)/xmake/precompile.json.in", {pattern = "@(.-)@"})
    after_build(function (target)
        import("core.project.config")
        os.mkdir("$(projectdir)/bin")

        os.rm("$(projectdir)/bin/*.ini")
        os.cp("$(projectdir)/data/*.ini", "$(projectdir)/bin")
        os.rm("$(projectdir)/bin/asset-test")
        os.cp("$(projectdir)/data/asset-test", "$(projectdir)/bin")
        os.rm("$(projectdir)/bin/config")
        os.cp("$(projectdir)/data/config", "$(projectdir)/bin")
        os.rm("$(projectdir)/bin/shader")
        os.cp("$(projectdir)/data/shader", "$(projectdir)/bin")

        local targetfile = target:targetfile()
        print("build %s", targetfile)
    end)
end)