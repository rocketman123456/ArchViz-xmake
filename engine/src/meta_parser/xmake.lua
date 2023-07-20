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
        add_linkdirs("$(projectdir)/engine/3rd_party/llvm_lib/lib/linux")
        add_links("libclang")
    end
    on_load(function (target)
        if is_plat("linux", "macosx") then
            target:add("links", "pthread", "m", "dl")
        end
    end)
    after_build(function (target)
        import("core.project.config")
        local targetfile = target:targetfile()
        os.mkdir("$(projectdir)/bin/tool")
        os.cp(targetfile, path.join("$(projectdir)/bin/tool", path.filename(targetfile)))
        print("build %s", targetfile)

        print("*************************************************************")
        print("**** [Precompile] Begin ")
        print("*************************************************************")
        print("")

        -- project_input_src include_file_path include_path include_sys module_name is_show_errors
        local cmd= ". $(projectdir)/bin/tool/meta_parser.exe \"$(projectdir)/engine/src/runtime\" \"$(projectdir)/build/parser_header.h\" \"$(projectdir)/engine/src\" \"*\" \"ArchViz\" 0"
        print(cmd)
        os.exec(cmd);

        print("*************************************************************")
        print("**** [Precompile] Finish ")
        print("*************************************************************")
        print("")
    end)
end)
