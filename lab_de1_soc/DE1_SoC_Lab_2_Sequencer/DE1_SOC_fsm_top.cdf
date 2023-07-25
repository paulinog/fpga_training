/* Quartus Prime Version 22.1std.1 Build 917 02/14/2023 SC Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("D:/gpaulino/fpga_training-solutions/lab_de1_soc/DE1_SoC_Lab_2_Sequencer/") File("DE1_SOC_fsm_top.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
