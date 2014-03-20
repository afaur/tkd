/**
 * Element module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.element;

/**
 * Imports.
 */
import std.array;
import std.conv;
import std.digest.crc;
import std.random;
import tkd.interpreter;

/**
 * The ui element base class.
 */
abstract class Element
{
	/**
	 * The Tk interpreter.
	 */
	protected Tk _tk;

	/**
	 * An optional identifier that overrides the generated id.
	 */
	private string _identifier;

	/**
	 * Internal element identifier.
	 */
	protected string _elementId;

	/**
	 * The unique hash of this element.
	 */
	protected string _hash;

	/**
	 * Construct the element.
	 */
	public this()
	{
		this._tk        = Tk.getInstance();
		this._elementId = "element";
		this._hash      = this.generateHash();
	}

	/*
	 * Override the unique id of this element. This method is intended for 
	 * internal use only and if used can have unintended consequences.
	 *
	 * Params:
	 *     identifier = The overriden identifier.
	 */
	public void overrideGeneratedId(string identifier) nothrow
	{
		this._identifier = identifier;
	}

	/**
	 * The unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	public @property string id() nothrow
	{
		if (this._identifier !is null)
		{
			return this._identifier;
		}

		return this._elementId ~ "-" ~ this._hash;
	}

	/**
	 * Generate the unique hash for this element.
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash()
	{
		string text = Random(unpredictableSeed).front.to!(string);
		return hexDigest!(CRC32)(text).array.to!(string);
	}

	/**
	 * Generate the unique hash for this element.
	 *
	 * Params:
	 *     text = The format of the text to generate a hash of.
	 *     args = The arguments that the format defines (if any).
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash(A...)(string text, A args)
	{
		return hexDigest!(CRC32)(format(text, args)).array.to!(string);
	}
}
