//      Copyright 2009 Ivan Rodriguez Murillo
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//	http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
package com.wantez.eregparser;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

public class Parser {
	private final Logger log = Logger.getLogger(this.getClass());
	private javax.xml.transform.Transformer transformer;

	public Parser(final String xsl) throws TransformerConfigurationException {
		final TransformerFactory tFactory = TransformerFactory.newInstance();

		final ClassLoader classLoader = this.getClass().getClassLoader();
		final InputStream stream = classLoader.getResourceAsStream(xsl);
		final StreamSource streamSource = new StreamSource(stream);
		streamSource.setSystemId(classLoader.getResource(xsl).getPath());
		this.transformer = tFactory.newTransformer(streamSource);

	}

	public void parse(final String input, final String output)
			throws FileNotFoundException, TransformerException {
		this.log.info(input + " -> " + output);
		final StreamSource streamSource = new StreamSource(input);
		final StreamResult streamResult = new StreamResult(
				new FileOutputStream(output));
		this.transformer.transform(streamSource, streamResult);

	}

	public String parse(final String document) throws TransformerException,
			UnsupportedEncodingException {
		Source streamSource = new StreamSource(IOUtils.toInputStream(document));
		String result;
		final ByteArrayOutputStream baos = new ByteArrayOutputStream();
		Result streamResult = new StreamResult(baos);
		this.transformer.transform(streamSource, streamResult);
		result = baos.toString("ISO-8859-1");
		return result;
	}
}
