return {
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>jb", function() require("java.tasks").run("build") end, desc = "Java: build without tests" },
      { "<leader>ja", function() require("java.tasks").run("test") end, desc = "Java: all module tests" },
      { "<leader>js", function() require("java.tasks").run("boot") end, desc = "Spring Boot: run" },
      { "<leader>jd", function() require("java.tasks").run("debug") end, desc = "Spring Boot: run with debug port" },
    },
  },
}
