package test;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.commons.io.FileUtils;
import org.junit.BeforeClass;
import org.junit.Test;

import com.wantez.eregparser.Parser;

public class MainTest {

	private static Parser parserXLS;
	private static Parser parserCSV;
	private static Parser parserHeaderXLS;
	private static Parser parserHeaderCSV;

	@Test
	public final void testCSV() throws FileNotFoundException,
			TransformerException {
		parserCSV.parse("src/test/resources/REGTEL_XFDF_JUST_1.xml",
				"target/test-resources/REGTEL_XFDF_JUST_1.csv");

	}

	@BeforeClass
	public static void env() throws TransformerConfigurationException {
		final File dir = new File("target/test-resources/");
		dir.mkdir();
		parserXLS = new Parser("xls-adapter.xsl");
		parserCSV = new Parser("csv-adapter.xsl");

		parserHeaderXLS = new Parser("xls-header-adapter.xsl");
		parserHeaderCSV = new Parser("csv-header-adapter.xsl");
	}

	@Test
	public final void testXLS() throws FileNotFoundException,
			TransformerException {
		parserXLS.parse("src/test/resources/REGTEL_XFDF_JUST_1.xml",
				"target/test-resources/REGTEL_XFDF_JUST_1.xls.csv");

	}

	@Test
	public final void testAppendXLS() throws IOException, TransformerException {
		String string = FileUtils.readFileToString(new File(
				"src/test/resources/REGTEL_XFDF_JUST_1.xml"));
		String string2 = FileUtils.readFileToString(new File(
				"src/test/resources/REGTEL_XFDF_JUST_2.xml"));

		String header = parserHeaderXLS.parse(string);
		String data = header + parserXLS.parse(string)
				+ parserXLS.parse(string2);

		FileUtils.writeStringToFile(new File(
				"target/test-resources/REGTEL_XFDF_JUST.xls.csv"), data);

	}

	@Test
	public final void testAppendCSV() throws IOException, TransformerException {
		String string = FileUtils.readFileToString(new File(
				"src/test/resources/REGTEL_XFDF_JUST_1.xml"));
		String string2 = FileUtils.readFileToString(new File(
				"src/test/resources/REGTEL_XFDF_JUST_2.xml"));

		String header = parserHeaderCSV.parse(string);
		String data = header + parserCSV.parse(string)
				+ parserCSV.parse(string2);

		FileUtils.writeStringToFile(new File(
				"target/test-resources/REGTEL_XFDF_JUST.csv"), data);

	}

}
