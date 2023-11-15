### A Pluto.jl notebook ###
# v0.19.30

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 0fe65f3a-dbec-4af7-8f80-2c7adc135f22
using PlutoUI

# ╔═╡ 3a1c7332-7b84-11ee-14b6-55c04f9f129a
html"<button onclick='present()'>present</button>"

# ╔═╡ 06a54ef7-f58b-4a45-a242-88c340b2c7b1
md"""
# IO in Pluto
‫بیشتر روش‌های ورودی و خروجی که تا به حال دیدیم، به استثنا ورودی استاندارد stdin در پلوتو هم کار می‌کنند. اما پلوتو امکاناتی دارد که ورودی گرفتن را راحت‌تر می‌کند؛ در ادامه با این ورودی‌ها آشنا می‌شویم. برای استفاده راحت‌تر از این امکانات نیاز داریم پکیج زیر را فراخوانی کنیم:
"""

# ╔═╡ 0a3731c2-cd18-4703-975d-70190f5c2c9d
md"""
‫این پکیج با ماکرو ````@bind```` به ما امکانات زیر را می‌دهد:
"""

# ╔═╡ 94135660-3367-4659-8d73-72f19eb8ddc7
md"""
- Slider
- Scrubbable
- NumberField
- CheckBox
- TextField
- Select
- MultiSelect
- MultiCheckBox
- ...
"""

# ╔═╡ d909afc2-c9e8-48f5-bff8-751a1b0939f0
md"""
## What is a macro?
‫این اولین بار است که به وضوح با یک ماکرو روبرو می‌شویم. ماکروها (که عموما با `@` شروع می‌شوند) قابلیت ویژه هستند که جولیا دارد، و معادل خاصی در زبان‌هایی مثل Python و R ندارد. ماکروها به ما این امکان را می‌دهد که متن کد نوشته شده را قبل از اجرا تغییر دهیم و سپس برنامه را اجرا کنیم. همواره می‌توان به جای استفاده از یک ماکرو جوری برنامه را نوشت که از آن‌ها استفاده نشود، لکن با استفاده از ماکروها می‌توان از نوشتن قسمت‌های طولانی و تکراری کد پرهیز کرد.

‫ماکروها جزو ابزارهای پیشرفته فرابرنامه‌نویسی (metaprogramming) محسوب شده و در این درس به نحوه تعریف آن‌ها نمی‌پردازیم؛ صرفا از بعضی ماکروهای به درد بخور در شرایط مناسب استفاده خواهیم کرد.
"""

# ╔═╡ 9868cd77-d817-4642-af85-fcf176661cb0
md"""
## Slider

"""

# ╔═╡ c99801d7-4fb6-4488-8847-c68a98a7b498
@bind x Slider(1:10)

# ╔═╡ 47f6c816-2732-412b-ada4-b27c56304ea1
x

# ╔═╡ 14020b01-908b-4837-86cd-ebec0d37e2da
md"""
‫اگر چه لزومی ندارد که مقادیر داخل Slider مرتب باشند، ولی از نظر منطقی قطعا بهتر است این گونه باشد.
"""

# ╔═╡ ea11aa23-e6dc-4bac-aecf-f2e22a38cc5c
@bind y Slider(rand(5))

# ╔═╡ fc029c4e-74ba-4dbc-beb7-56e105186b98
md"""
## Scrubbable
_If Alice has $(@bind a Scrubbable(20))_ 🍎_s, 
and she gives $(@bind b Scrubbable(3))_ 🍎_s to Bob..._
"""

# ╔═╡ c5561de0-12b2-4e58-b803-ab07f1c87ced
a

# ╔═╡ 39967e95-453f-4f85-93b6-0bc05c47f8c7
md"""
_...then Alice has **$(a - b)** 🍎s left._
"""

# ╔═╡ bbd5e291-86b0-447c-a86b-29d8aa291501
md"""
‫با نگه‌داشتن کلیک و جابجا کردن موس می‌توان مقادیر این‌ها را تغییر داد.
"""

# ╔═╡ 6e9a8f04-b52d-4e4d-ac51-4d09cb05f217
md"""
## NumberField
‫مشابه Slider می‌باشد، فقط نوع وارد کردن ورودی متفاوت است.
"""

# ╔═╡ f722717a-9012-489b-902f-9841842c4f00
@bind χ NumberField(1:100, 20)

# ╔═╡ 831523ea-0a1c-4ef4-86a2-b4382e525dca
println("x*χ = ", x*χ)

# ╔═╡ 8d2da339-3cbe-4531-82b0-70a03ffe7a9e
md"""
## Checkbox
‫اگر تیک خورده باشد مقدار true وگرنه مقدار false را برمی‌گرداند.
"""

# ╔═╡ b6cd1667-9158-438d-89fd-5bd9ead9847e
@bind chk CheckBox(default = true)

# ╔═╡ a414f17c-1876-4c74-8b1a-8c967182ef54
chk ? md"😄" : md"🤢"

# ╔═╡ 4478db87-b938-4064-b844-4c749d34de27
md"""
## TextField
‫با این دستور می‌توان جایی برای گرفتن ورودی‌های رشته‌ای قرار داد:
"""

# ╔═╡ 2e70e31a-ea58-48a8-b3c5-c21cdc09fe09
@bind name TextField(default = "🐱")

# ╔═╡ dc0a4498-8a47-4bca-a755-a06f502e02ef
md"Hello $name !"

# ╔═╡ a06ef9b2-da6f-4d61-ba13-c6a48ef5d5a9
md"""
## Select
‫با استفاده از این دستور می‌توان چند گزینه به کاربر داد تا از میان آن‌ها انتخاب کند:
"""

# ╔═╡ f2969bee-97fe-49a6-a756-108fac90a504
md"""
میوهٔ مورد علاقه شما کدام مورد است؟
"""

# ╔═╡ b4a10814-5075-4dc4-84b2-527b93927037
@bind fruit Select([md"🍏",md"🍍",md"🍐",md"🍊",md"🥒",md"🍑",md"🍉",md"🍅",md"🥝",md"🥭"])

# ╔═╡ 3b85260c-ef46-4c7b-8efa-f115abb3dc00
fruit == md"🍅" ? md"🤦, 🍅 isn't a fruit, it's a vegetable!" : md"Yummy, $fruit s are delicious!"

# ╔═╡ 9861d8d4-4ddf-4a3a-9bfa-965b6a28730c
md"""
## MultiSelect and MultiCheckBox
‫این دو مشابه `Select` و `CheckBox` بوده با این تفاوت که امکان انتخاب چند گزینه هم وجود دارد. برای انتخاب چند گزینه در مورد ‍`MultiSelect` لازم است کلید `Ctrl` را نگه‌داشت.
"""

# ╔═╡ aa471fa3-b7e6-4ee1-a5cc-5e094876a8cf
@bind fruit_basket MultiCheckBox(["apple", "blueberry", "mango"])

# ╔═╡ 1599d19a-f130-494b-8dc7-8bb2e5af7890
fruit_basket

# ╔═╡ 636b18f3-2276-4647-bd40-720583dab268
@bind vegetable_basket MultiSelect(["potato", "carrot", "boerenkool"])

# ╔═╡ 41a07672-6f05-462b-82c8-9b110bf9c934
vegetable_basket

# ╔═╡ d6718c3b-ef96-4acd-a447-651cf57a9a97
md"""
‫آرایهٔ ورودی به این توابع لازم نیست حتما از جنس رشته باشد، بلکه هر تایپ خاصی که بگذارید قبول می‌کند. مثلا:
"""

# ╔═╡ 62bc569a-1f29-43d2-9359-73a020f40ee9
@bind my_functions MultiCheckBox([sin, cos, tan, cot, exp])

# ╔═╡ e8490e55-6721-4ce9-ae16-3255f2cf9ec4
[f(π) for f in my_functions]

# ╔═╡ fcb82cbc-d258-491c-9067-f8ab40493bf5
md"""
# تمرین
‫با استفاده از نکاتی که در این نتبوک فراگرفتید، خطوط زیر را از کامنت خارج کرده و کامل کنید تا ماشین‌حسابی ساده که دو عدد و یک عملیات به عنوان ورودی می‌گیرد و حاصل را چاپ می‌کند بسازید:
"""

# ╔═╡ 141e0c37-79ee-4e2c-bb24-004c31dbf091
# md"""
# - First number = $(@bind num1 ...)
# - Second number = $(@bind num2 ...)
# - Operation = $(@bind op ...)
# - Result = $(op(...))
# """

# ╔═╡ 4283fe09-3e86-467e-b953-9576d2d6b5e3
md"""
# تمرین
‫سلولهای زیر را از کامنت خارج کرده و آن‌ها را اجرا کنید:
"""

# ╔═╡ 884199eb-3271-4aae-acd6-cd22a0db62c5
# @bind n Slider(2:100, default = 10, show_value = true)

# ╔═╡ 0ff47053-e11c-4191-a5d5-066e6bb30234
# open("sines.txt","w") do io
# 	sines = [sin(2π*j/n) for j in 0:n-1]
# 	for s in sines
# 		write(io,"$s\n")
# 	end
# end

# ╔═╡ 048118bb-0870-45a3-a19a-e3cf64a22ecd
# open("cosines.txt","w") do io
# 	cosines = [cos(2π*j/n) for j in 0:n-1]
# 	for s in cosines
# 		write(io,"$s\n")
# 	end
# end

# ╔═╡ 1bba54c0-2c10-40dc-a915-ce13ad8529f8
md"""
‫برنامه‌ای بنویسید که محتویات این دو فایل را خوانده و توابع زیر را روی آن‌ها پیاده کرده و خروجی را چاپ نماید:
- ح‫اصل جمع اعداد فایل `sines.txt`
- ح‫اصل ضرب اعداد فایل `cosines.txt`
- مجموع توان دوم اعداد هر دو این فایل‌ها
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "f5c06f335ceddc089c816627725c7f55bb23b077"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─3a1c7332-7b84-11ee-14b6-55c04f9f129a
# ╟─06a54ef7-f58b-4a45-a242-88c340b2c7b1
# ╠═0fe65f3a-dbec-4af7-8f80-2c7adc135f22
# ╟─0a3731c2-cd18-4703-975d-70190f5c2c9d
# ╟─94135660-3367-4659-8d73-72f19eb8ddc7
# ╟─d909afc2-c9e8-48f5-bff8-751a1b0939f0
# ╟─9868cd77-d817-4642-af85-fcf176661cb0
# ╠═c99801d7-4fb6-4488-8847-c68a98a7b498
# ╠═47f6c816-2732-412b-ada4-b27c56304ea1
# ╟─14020b01-908b-4837-86cd-ebec0d37e2da
# ╠═ea11aa23-e6dc-4bac-aecf-f2e22a38cc5c
# ╠═c5561de0-12b2-4e58-b803-ab07f1c87ced
# ╟─fc029c4e-74ba-4dbc-beb7-56e105186b98
# ╟─39967e95-453f-4f85-93b6-0bc05c47f8c7
# ╟─bbd5e291-86b0-447c-a86b-29d8aa291501
# ╟─6e9a8f04-b52d-4e4d-ac51-4d09cb05f217
# ╠═f722717a-9012-489b-902f-9841842c4f00
# ╠═831523ea-0a1c-4ef4-86a2-b4382e525dca
# ╟─8d2da339-3cbe-4531-82b0-70a03ffe7a9e
# ╠═b6cd1667-9158-438d-89fd-5bd9ead9847e
# ╟─a414f17c-1876-4c74-8b1a-8c967182ef54
# ╟─4478db87-b938-4064-b844-4c749d34de27
# ╠═2e70e31a-ea58-48a8-b3c5-c21cdc09fe09
# ╟─dc0a4498-8a47-4bca-a755-a06f502e02ef
# ╟─a06ef9b2-da6f-4d61-ba13-c6a48ef5d5a9
# ╟─f2969bee-97fe-49a6-a756-108fac90a504
# ╠═b4a10814-5075-4dc4-84b2-527b93927037
# ╟─3b85260c-ef46-4c7b-8efa-f115abb3dc00
# ╟─9861d8d4-4ddf-4a3a-9bfa-965b6a28730c
# ╠═aa471fa3-b7e6-4ee1-a5cc-5e094876a8cf
# ╠═1599d19a-f130-494b-8dc7-8bb2e5af7890
# ╠═636b18f3-2276-4647-bd40-720583dab268
# ╠═41a07672-6f05-462b-82c8-9b110bf9c934
# ╟─d6718c3b-ef96-4acd-a447-651cf57a9a97
# ╠═62bc569a-1f29-43d2-9359-73a020f40ee9
# ╠═e8490e55-6721-4ce9-ae16-3255f2cf9ec4
# ╟─fcb82cbc-d258-491c-9067-f8ab40493bf5
# ╠═141e0c37-79ee-4e2c-bb24-004c31dbf091
# ╟─4283fe09-3e86-467e-b953-9576d2d6b5e3
# ╠═884199eb-3271-4aae-acd6-cd22a0db62c5
# ╠═0ff47053-e11c-4191-a5d5-066e6bb30234
# ╠═048118bb-0870-45a3-a19a-e3cf64a22ecd
# ╟─1bba54c0-2c10-40dc-a915-ce13ad8529f8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
