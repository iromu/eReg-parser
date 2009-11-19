package test;

import java.io.File;

import org.junit.Test;

import com.wantez.eregparser.Parser;

public class MainTest {


	@Test
	public final void testCSV() {
		final Parser main = new Parser("csv-adapter.xsl");
		final File dir = new File("target/test-resources/");
		dir.mkdir();
		main.parse("src/test/resources/REGTEL_XFDF_JUST.xml",
				"target/test-resources/REGTEL_XFDF_JUST.csv");

	}

	@Test
	public final void testXLS() {
		final Parser main = new Parser("xls-adapter.xsl");
		final File dir = new File("target/test-resources/");
		dir.mkdir();
		main.parse("src/test/resources/REGTEL_XFDF_JUST.xml",
				"target/test-resources/REGTEL_XFDF_JUST.xls.csv");

	}

}
