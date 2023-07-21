target("meta_parser", function ()
    set_kind("binary")
    add_headerfiles("parser/**.h")
    add_files("parser/**.cpp")
    add_includedirs("$(projectdir)/engine/3rd_party/mustache")
    add_includedirs("$(projectdir)/engine/3rd_party/llvm_lib/include")
    add_includedirs("$(projectdir)/engine/src/meta_parser/parser")
    if is_plat("windows") then 
        add_linkdirs("$(projectdir)/engine/3rd_party/llvm_lib/lib/windows")
        add_links("libclang")
    elseif is_plat("macos") then 
        add_linkdirs("$(projectdir)/engine/3rd_party/llvm_lib/lib/macos")
        add_links("libclang")
    elseif is_plat("linux") then 
        -- work on ubuntu 22.04, should try more systems
        add_linkdirs("$(projectdir)/engine/3rd_party/llvm_lib/lib/linux")
        add_links("$(projectdir)/engine/3rd_party/llvm_lib/lib/linux/libclang-14.so")
    end
    on_load(function (target)
        if is_plat("linux", "macosx") then
            target:add("links", "pthread", "m", "dl")
        end
    end)
    on_load(function (target)
        import("core.project.config")

        local targetfile = target:targetfile()

        local parser = path.join("$(projectdir)/bin/tool", path.filename(targetfile))
        local params = "\"$(projectdir)/engine/src/runtime\""
        local ipnut = "\"$(projectdir)/build/parser_header.h\""
        local source_dir = "\"$(projectdir)/engine/src\""
        local include_dir = "*"
        if is_plat("linux") then
            include_dir = "/usr/include/c++/9/"
        elseif is_plat("macosx") then
            include_dir = "${osx_sdk_platform_path_test}/../../Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1"
        end
        local namespace = "ArchViz"
        local opt = 0

        local file, err = io.open(parser, "r")
        if err == nil then 
            print("*************************************************************")
            print("**** [Precompile] Begin ")
            print("*************************************************************")
            print("")
            -- project_input_src include_file_path include_path include_sys module_name is_show_errors
            local cmd= parser .. " " .. params .. " " .. ipnut .. " " .. source_dir .. " " .. include_dir .. " " .. namespace .. " " .. opt
            print(cmd)
            print("")
            os.exec(cmd);

            print("*************************************************************")
            print("**** [Precompile] Finish ")
            print("*************************************************************")
            print("")
        end
    end)
    after_build(function (target)
        import("core.project.config")

        local targetfile = target:targetfile()
        os.mkdir("$(projectdir)/bin/tool")
        os.cp(targetfile, path.join("$(projectdir)/bin/tool", path.filename(targetfile)))
        if is_plat("windows") then 
            os.cp("$(projectdir)/engine/3rd_party/llvm_lib/bin/windows/*.dll", "$(projectdir)/bin/tool")
        elseif is_plat("macos") then 
            os.cp("$(projectdir)/engine/3rd_party/llvm_lib/bin/windows/*.dylib", "$(projectdir)/bin/tool")
        elseif is_plat("linux") then 
            os.cp("$(projectdir)/engine/3rd_party/llvm_lib/bin/windows/*.so", "$(projectdir)/bin/tool")
        end
        print("build %s", targetfile)
    end)
end)
