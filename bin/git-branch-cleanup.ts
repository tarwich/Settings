const env = Deno.env();
const decoder = new TextDecoder("utf-8");

async function shell(args) {
  return decoder.decode(
    await Deno.run({
      args,
      stdout: "piped",
      env
    }).output()
  );
}

async function main() {
  const branches = (await shell([
    "git",
    "branch",
    "--format",
    "%(HEAD)%(objectname):%(refname:short)"
  ]))
    .split("\n")
    .map(line => line.trim())
    .filter(line => line && line[0] !== "*" && line.includes("/"))
    .map(line => {
      const [hash, branch] = line.split(":");
      return { branch, hash };
    });

  const results = await Promise.all(
    branches.map(async branchInfo => {
      const { branch, hash } = branchInfo;
      const merged = await shell([
        "git",
        "branch",
        "--contains",
        hash,
        "master"
      ]);
      console.log(`${merged ? "MERGED" : "DIRTY "} ${hash} - ${branch}`);
      if (merged) await shell(["git", "branch", "-d", branch]);
      return { branch, hash, merged };
    })
  );

  console.log(
    `Deleted ${results.filter(result => result.merged).length} branches`
  );
}

main();
