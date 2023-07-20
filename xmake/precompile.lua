function meta_compile(parser, params, input, source_dir, include_dir, namespace, opt)
    os.execute(parser .. " ".. params .. " " .. input .. " " .. source_dir .. " " .. include_dir .. " " .. namespace .. " " .. opt)
end

rule("precompile")
    set_extensions(".md", ".markdown")
    after_build(function(target)
        print("*************************************************************")
        print("**** [Precompile] Begin ")
        print("*************************************************************")
        print("")
        
        local params = "precompile.json"
        local ipnut = "parser_header.h"
        local source_dir = "source"
        local include_dir = "*"
        if is_plat("linux") then
            include_dir = "/usr/include/c++/9/"
        elseif is_plat("macosx") then
            include_dir = os.getenv("osx_sdk_platform_path_test").."/../../Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1"
        end
        local namespace = "ArchViz"
        local opt = 0
        -- os.execute("echo *************************************************************")

        print("*************************************************************")
        print("**** [Precompile] Finish ")
        print("*************************************************************")
        print("")
    end)
